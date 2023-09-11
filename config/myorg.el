;; ORG-MODE
(use-package org
  :bind ("C-c a" . org-agenda)
  (:map org-mode-map
        ("<M-right>" . nil)
        ("<M-left>" . nil)
        ("s-<left>" . org-metaleft)
        ("s-<right>" . org-metaright)
        ("C-S-<left>" . org-shiftleft)
        ("C-S-<right>" . org-shiftright)
        )
  (:map org-read-date-minibuffer-local-map
        ("C-S-<left>" . (lambda () (interactive)
                          (org-eval-in-calendar '(calendar-backward-day 1))))
        ("C-S-<right>" . (lambda () (interactive)
                           (org-eval-in-calendar '(calendar-forward-day 1))))
        ("C-S-<up>" . (lambda () (interactive)
                        (org-eval-in-calendar '(calendar-backward-week 1))))
        ("C-S-<down>" . (lambda () (interactive)
                          (org-eval-in-calendar '(calendar-forward-week 1)))))
  
  :config
  (setq
   org-log-done 'time
   org-startup-indented t
   org-startup-folded t
   org-log-state-notes-insert-after-drawers t
   org-log-state-notes-into-drawer t
   org-agenda-dim-blocked-tasks 'invisible
   org-blank-before-new-entry '((heading . auto) (plain-list-item . nil))
   org-cycle-separator-lines -1
   org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t%s%b")
                              (todo . " %i %-12:c%b")
                              (tags . " %i %-12:c%b")
                              (search . " %i %-12:c%b"))
   org-agenda-breadcrumbs-separator ">"
   org-clock-mode-line-total 'current
   org-archive-location "~/org/archive::* From %s"))


(if (string-equal system-name "FJH6HCXTJN")
    ;; Work refile and agenda
    (setq org-agenda-files (list "~/org/organiser.org")
          org-agenda-todo-list-sublevels nil
          )
  ;; Home refile and agenda
  (setq org-refile-targets '(("repeated.org" :maxlevel . 1)
                             ("diary.org" :maxlevel . 1)
                             ("!todo.org" :maxlevel . 1)
                             ("zbacklog.org" :maxlevel . 1)
                             ("projects.org" :maxlevel . 1)
                             ("piano.org" :maxlevel . 1))
        org-refile-use-outline-path 'file))
