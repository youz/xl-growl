;;; -*- mode:lisp; package:growl -*-

;;; growl.l --- GNTP (Growl Network Transport Protocol) Library for xyzzy

;; Copyright (c) 2009-2011  Yousuke Ushiki
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.

;; Growl for Windows  http://www.growlforwindows.com/gfw/default.aspx
;; GNTP specification http://www.growlforwindows.com/gfw/help/gntp.aspx

(provide "growl")

(defpackage :growl
  (:use :lisp :editor))

(in-package :growl)
(export '(*default-name*
	  *default-icon*
;	  register
	  notify
	  notify-with-url-callback
	  notify-with-socket-callback
	  ))

(defvar *default-name* "xyzzy")
(defvar *default-icon* "data:image/png;base64,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")


(defconstant +gntp-version+ "1.0")
(defconstant +gntp-port+ 23053)

(defparameter *callback-timeout* nil
  "growl:notify-with-socket-callback使用時に接続を維持する時間(秒)")


;;; util
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defmacro whenlet (sym test &body body)
    `(let ((,sym ,test)) (when ,sym ,@body)))
  )

(defun to-utf8n (str)
  (convert-encoding-from-internal *encoding-utf8n* str))


;;; GNTP base
(defun send (host request encryption data)
  (with-open-stream (cn (connect host +gntp-port+ :encoding :binary))
    (format cn "GNTP/~A ~A ~A\r\n~
                ~{~@[~A: ~A~]\r\n~}"
	    +gntp-version+ request encryption data)
    (princ "\r\n" cn)
    (let ((result (read-line cn nil)))
      (if (string-match "^GNTP/[0-9.]+ -OK NONE" result)
	  t
	(error "~A" result)))))

(defvar *connections* (make-hash-table :test #'eq))

(defun send/callback (host request encryption data callback)
  (let* ((cn (connect host +gntp-port+ :encoding :binary))
	 (start (get-internal-real-time)))
    (format cn "GNTP/~A ~A ~A\r\n~{~@[~A: ~A~]\r\n~}\r\n"
	    +gntp-version+ request encryption data)
    (let ((res (read-line cn nil)))
      (unless (string-match "^GNTP/1.0 -OK NONE" res)
	(error "~A" res)))
    (while (string/= (read-line cn) "\r"))
    (let ((cbid (gensym "growl-notify-callback")))
      (labels ((read-callback ()
		 (while (not (string-match "^GNTP/[0-9.]+ -CALLBACK" (read-line cn))))
		 (do ((l #0=(read-line cn) #0#)
		      (res nil))
		     ((string= l "\r") (nreverse res))
		   ;; get header-name & value
		   (when (string-match "^\\(^[^:]+\\): *\\(.+\\)\r" l)
		     (push (intern (string-downcase (match-string 1)) "growl") res)
		     (push (match-string 2) res))))
	       (listener ()
		 (if (listen cn)
		     (let ((res (read-callback)))
		       (cancel-callback cbid)
		       (funcall callback res))
		   (when (and *callback-timeout*
			      (> (/ (- (get-internal-real-time) start) 1000)
				 *callback-timeout*))
		     (cancel-callback cbid)
		     (funcall callback '(notification-callback-result :timeout))
		     ))))
	(setf (gethash cbid *connections*) (list cn #'listener))
	(start-timer 0.5 #'listener))
      cbid)))

(defun cancel-callback (id)
  (whenlet p (gethash id  *connections*)
    (stop-timer (cadr p))
    (when (open-stream-p (car p))
      (close (car p)))
    (remhash id *connections*)
    t))

(defun cancel-callback-all ()
  (maphash #'(lambda (id p) (cancel-callback id))
	   *connections*)
  t)


;;; exports
(defun register (name &key (host "localhost") appicon)
  "通知アプリケーション登録"
  (send host "REGISTER" "NONE"
	(list "Application-Name" "xyzzy"
	      "Notifications-Count" 1
	      () ;empty line
	      "Notification-Name" (to-utf8n name)
	      "Notification-Display-Name" (to-utf8n name)
	      "Notification-Enabled" "True")
	))

(defun notify (title text
		&key (host "localhost")
		     (name *default-name*)
		     (icon *default-icon*)
		     (priority 0)
		     (sticky nil))
  "通知"
  (register name :host host)
  (send host "NOTIFY" "NONE"
	(list "Application-Name" "xyzzy"
	      "Notification-Name" (to-utf8n name)
	      "Notification-Title" (to-utf8n title)
	      "Notification-Text" (to-utf8n text)
	      "Notification-Icon" icon
	      "Notification-Priority" priority
	      "Notification-Sticky" (if sticky "True" "False")
	      )))

(defun notify-with-url-callback
  (title text url
    &key (host "localhost")
	 (name *default-name*)
	 (icon *default-icon*)
	 (priority 0)
	 (sticky nil))
  "URLコールバック付き通知"
  (register name :host host)
  (send host "NOTIFY" "NONE"
	(list "Application-Name" "xyzzy"
	      "Notification-Name" (to-utf8n name)
	      "Notification-Title" (to-utf8n title)
	      "Notification-Text" (to-utf8n text)
	      "Notification-Callback-Target" (to-utf8n url)
	      "Notification-Icon" icon
	      "Notification-Priority" priority
	      "Notification-Sticky" (if sticky "True" "False")
	      )))

(defun notify-with-socket-callback
  (title text context context-type
	 &key (host "localhost")
	 (name *default-name*)
	 (icon *default-icon*)
	 (priority 0)
	 (sticky  nil)
	 onclick onclose ontimeout handler)
  "ソケットコールバック付き通知"
  (register name :host host)
  (labels
      ((cb (res)
	 (let* ((result (getf res 'notification-callback-result))
		(data (list :name (getf res 'application-name)
			    :result result
			    :timestamp (getf res 'notification-callback-timestamp)
			    :context (getf res 'notification-callback-context)
			    :context-type (getf res 'notification-callback-context-type))))
	   (if handler
	       (apply handler data)
	     (cond ((string-match "CLICKED\\|CLICK" result)
		    (apply onclick data))
		   ((string-match "CLOSED\\|CLOSE" result)
		    (apply onclose data))
		   ((string-match "TIMEDOUT\\|TIMEOUT" result)
		    (apply ontimeout data))
		   (t (error "GNTP Callback Unknown Result~{~%~A~^: ~A~}" data))))
	   )))
    (send/callback host "NOTIFY" "NONE"
		   (list "Application-Name" "xyzzy"
			 "Notification-Name" (to-utf8n name)
			 "Notification-Title" (to-utf8n title)
			 "Notification-Text" (to-utf8n text)
			 "Notification-Icon" icon
			 "Notification-Priority" priority
			 "Notification-Sticky" (if sticky "True" "False")
			 "Notification-Callback-Context" (to-utf8n context)
			 "Notification-Callback-Context-Type" (to-utf8n context-type))
		   #'cb)))


(defun user::growl (title text)
  (interactive "sTitle: \nsText: ")
  (growl::notify title text))



#+:nil
(labels ((msg-org (fmt &rest args)
	   (terpri ed::*status-window*)
	   (apply #'format ed::*status-window* fmt args)
	   (terpri ed::*status-window*))
	 (msg-growl (fmt &rest args)
	   (growl::notify "---" (apply #'format nil fmt args))))
  (let ((state nil))
    (defun user::toggle-growl ()
      (interactive)
      (setf (symbol-function 'ed:message)
	    (if (setq state (null state)) #'msg-growl #'msg-org)))))
