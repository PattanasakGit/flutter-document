(function () {
  "use strict";

  var STORAGE_KEYS = {
    theme: "flutter-guide-theme",
    progress: "flutter-guide-progress",
  };

  var chapters = [];

  function safeGet(key) {
    try {
      return window.localStorage.getItem(key);
    } catch (_) {
      return null;
    }
  }

  function safeSet(key, value) {
    try {
      window.localStorage.setItem(key, value);
    } catch (_) {
      // Content remains usable when storage is blocked.
    }
  }

  function readProgress() {
    var value = safeGet(STORAGE_KEYS.progress);
    if (!value) return {};
    try {
      return JSON.parse(value) || {};
    } catch (_) {
      return {};
    }
  }

  function setTheme(theme) {
    var resolved = theme;
    if (theme === "system") {
      resolved = window.matchMedia("(prefers-color-scheme: dark)").matches
        ? "dark"
        : "light";
    }
    document.documentElement.dataset.theme = resolved;
    safeSet(STORAGE_KEYS.theme, theme);
    document.querySelectorAll("[data-theme-trigger]").forEach(function (button) {
      button.setAttribute(
        "aria-label",
        resolved === "dark" ? "ใช้โหมดสว่าง" : "ใช้โหมดมืด",
      );
    });
  }

  function toggleTheme() {
    var current = document.documentElement.dataset.theme || "light";
    setTheme(current === "dark" ? "light" : "dark");
  }

  function toggleNavigation(force) {
    var next =
      typeof force === "boolean"
        ? force
        : document.body.dataset.navOpen !== "true";
    document.body.dataset.navOpen = String(next);
    document.querySelectorAll("[data-nav-trigger]").forEach(function (button) {
      button.setAttribute("aria-expanded", String(next));
    });
  }

  function openSearch() {
    var dialog = document.getElementById("search-dialog");
    if (!dialog) return;
    if (typeof dialog.showModal === "function") {
      dialog.showModal();
    } else {
      dialog.setAttribute("open", "");
    }
    var input = document.getElementById("search-input");
    if (input) {
      input.value = "";
      renderSearch("");
      window.setTimeout(function () {
        input.focus();
      }, 0);
    }
  }

  function closeSearch() {
    var dialog = document.getElementById("search-dialog");
    if (!dialog) return;
    if (typeof dialog.close === "function") dialog.close();
    else dialog.removeAttribute("open");
  }

  function registerChapters(items) {
    chapters = items.slice();
    renderSearch("");
    updateProgressUI();
  }

  function renderSearch(query) {
    var results = document.getElementById("search-results");
    if (!results) return;

    var normalized = query.trim().toLocaleLowerCase("th");
    var matches = chapters.filter(function (chapter) {
      var haystack = [
        chapter.title,
        chapter.track,
        chapter.keywords || "",
      ]
        .join(" ")
        .toLocaleLowerCase("th");
      return !normalized || haystack.indexOf(normalized) !== -1;
    });

    if (matches.length === 0) {
      results.innerHTML =
        '<p class="search-empty">ไม่พบหัวข้อนี้ ลองค้นด้วยชื่อ API, layer หรือคำสั่ง</p>';
      return;
    }

    var root = document.body.dataset.root || "";
    results.innerHTML = matches
      .slice(0, 12)
      .map(function (chapter) {
        return (
          '<a class="search-result" href="' +
          root +
          chapter.url +
          '"><strong>' +
          escapeHtml(chapter.title) +
          "</strong><small>" +
          escapeHtml(chapter.track) +
          " · " +
          escapeHtml(chapter.keywords || "") +
          "</small></a>"
        );
      })
      .join("");
  }

  function escapeHtml(value) {
    return String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;");
  }

  function markComplete(chapterId, complete) {
    var progress = readProgress();
    if (complete) progress[chapterId] = true;
    else delete progress[chapterId];
    safeSet(STORAGE_KEYS.progress, JSON.stringify(progress));
    updateProgressUI();
  }

  function updateProgressUI() {
    var progress = readProgress();
    var completed = Object.keys(progress).filter(function (id) {
      return progress[id] === true;
    }).length;
    var total = chapters.filter(function (chapter) {
      return chapter.kind !== "reference";
    }).length;
    var percent = total === 0 ? 0 : Math.round((completed / total) * 100);

    document.querySelectorAll("[data-progress-count]").forEach(function (node) {
      node.textContent = completed + " / " + total;
    });
    document.querySelectorAll("[data-progress-value]").forEach(function (node) {
      node.style.width = percent + "%";
    });
    document
      .querySelectorAll("[data-current-chapter]")
      .forEach(function (button) {
        var id = button.getAttribute("data-current-chapter");
        var isComplete = progress[id] === true;
        button.setAttribute("aria-pressed", String(isComplete));
        button.textContent = isComplete
          ? "เรียนบทนี้แล้ว — กดเพื่อยกเลิก"
          : "ทำเครื่องหมายว่าเรียนจบบทนี้";
      });
  }

  function answerQuiz(button, correct) {
    var quiz = button.closest(".quiz");
    if (!quiz) return;
    quiz.querySelectorAll(".quiz-option").forEach(function (option) {
      option.dataset.state = "";
    });
    button.dataset.state = correct ? "correct" : "incorrect";
    var feedback = quiz.querySelector(".quiz-feedback");
    if (feedback) {
      feedback.textContent = correct
        ? button.dataset.correctFeedback || "ถูกต้อง เพราะคุณเลือกตาม ownership และ lifecycle"
        : button.dataset.incorrectFeedback || "ยังไม่ถูก ลองทบทวน mental model ด้านบน";
    }
  }

  function addCopyButtons() {
    document.querySelectorAll(".code-block").forEach(function (block) {
      if (block.querySelector(".copy-code")) return;
      var label = block.querySelector(".code-label");
      var code = block.querySelector("code");
      if (!label || !code) return;

      var button = document.createElement("button");
      button.type = "button";
      button.className = "copy-code";
      button.textContent = "คัดลอก";
      button.setAttribute("aria-label", "คัดลอกโค้ด");
      button.addEventListener("click", function () {
        if (!navigator.clipboard) return;
        navigator.clipboard.writeText(code.textContent).then(function () {
          button.textContent = "คัดลอกแล้ว";
          window.setTimeout(function () {
            button.textContent = "คัดลอก";
          }, 1400);
        });
      });
      label.appendChild(button);
    });
  }

  function bindEvents() {
    document.querySelectorAll("[data-theme-trigger]").forEach(function (button) {
      button.addEventListener("click", toggleTheme);
    });
    document.querySelectorAll("[data-nav-trigger]").forEach(function (button) {
      button.addEventListener("click", function () {
        toggleNavigation();
      });
    });
    document
      .querySelectorAll("[data-search-trigger]")
      .forEach(function (button) {
        button.addEventListener("click", openSearch);
      });

    var closeButton = document.querySelector("[data-search-close]");
    if (closeButton) closeButton.addEventListener("click", closeSearch);

    var searchInput = document.getElementById("search-input");
    if (searchInput) {
      searchInput.addEventListener("input", function (event) {
        renderSearch(event.target.value);
      });
    }

    document
      .querySelectorAll("[data-current-chapter]")
      .forEach(function (button) {
        button.addEventListener("click", function () {
          var id = button.getAttribute("data-current-chapter");
          var next = button.getAttribute("aria-pressed") !== "true";
          markComplete(id, next);
        });
      });

    document.querySelectorAll(".quiz-option").forEach(function (button) {
      button.addEventListener("click", function () {
        answerQuiz(button, button.dataset.correct === "true");
      });
    });

    document.addEventListener("keydown", function (event) {
      var target = event.target;
      var typing =
        target &&
        (target.tagName === "INPUT" ||
          target.tagName === "TEXTAREA" ||
          target.isContentEditable);
      if (event.key === "/" && !typing) {
        event.preventDefault();
        openSearch();
      }
      if (event.key === "Escape") {
        toggleNavigation(false);
      }
    });
  }

  function init() {
    var storedTheme = safeGet(STORAGE_KEYS.theme) || "system";
    setTheme(storedTheme);
    bindEvents();
    addCopyButtons();
    if (window.FlutterGuideCatalog) {
      registerChapters(window.FlutterGuideCatalog);
    } else {
      updateProgressUI();
    }
  }

  window.FlutterGuide = {
    answerQuiz: answerQuiz,
    closeSearch: closeSearch,
    markComplete: markComplete,
    openSearch: openSearch,
    registerChapters: registerChapters,
    renderSearch: renderSearch,
    setTheme: setTheme,
    toggleNavigation: toggleNavigation,
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
