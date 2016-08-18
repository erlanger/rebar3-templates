;; vim: set sw=2:

(defmodule index1
  (export 
    (main 0) (title 0) (body 0) 
    (wait_for_updates 0) (event 1)))

(include-lib "../include/wf.lfe")

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%                                Page
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
(defun main ()
  (wtemplate file ({{name}}:template "index.html")))
 
(defun title () "Welcome to {{name}}.")
 
(defun body ()
  (prog1 
    (list
      (wspan text "Trigger result: " )
      (wspan id 'triggerval text "N/A"
             style "width: 100px;" )
      (wtextbox id 'tbox text "hello")
      (binding_table))
    (start_comet)))


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%                                Binding
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
(defun bdata () 
 (list
  `("Aug 13" "Author 1" "Description 1" #(edit 1) #(del 1))
  `("Aug 14" "Author 2" "Description 2" #(edit 2) #(del 2))
  `("Aug 15" "Author 3" "Description 3" #(edit 3) #(del 3))
  `("Aug 16" "Author 4" "Description 4" #(edit 4) #(del 4))
  `("Aug 17" "Author 5" "Description 5" #(edit 5) #(del 5))))

(defun bmap ()
  `( dateLabel@text
     authorLabel@text
     descriptionLabel@text
     ac_edit@postback
     ac_del@postback))

(defun alternate_color 
 ([data-row acc] (when (or (== () acc) (== 'odd acc)))
	;Data   , new acc,  additional map bindings
	`#(,data-row even #(top@class "evenrow")))

 ([data-row acc] (when (== 'even acc))
	`#(,data-row odd #(top@class "oddrow"))))

(defun binding_table ()
	(list 
     #"<style>
         .oddrow { background-color: #8ba6ca;  }
			.evenrow { background-color: #fff1d2;  }
			th { font-size: 1.2em; }
	    </style>"
	  (wtable class 'tiny rows `(
       ,(wtablerow cells `(
			  ,(wtableheader text "Date")
			  ,(wtableheader text "Author")
			  ,(wtableheader text "Description")
			  ,(wtableheader)
			  ,(binding_data)))
		  ))))

(defun binding_data ()
 (wbind  id 'binding_data data (bdata) map (bmap)
         transform #'alternate_color/2
         body (wtablerow id 'top 
               cells 
               `( ,(wtablecell id 'dateLabel)
                  ,(wtablecell id 'authorLabel )
                  ,(wtablecell id 'descriptionLabel )
                  ,(wtablecell body 
                    `( ,(wlink id 'ac_edit class "glyphicon glyphicon-pencil" )
                       ,(wlink id 'ac_del class "glyphicon glyphicon-remove" )))))))

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%                                Comet
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
(defun start_comet ()
   (wf:wire (wcomet
              scope 'global
              pool 'indexpool
              function (lambda () (comet_setup))
              ;This event is fired after reconnection from
              ;the browser (the page is not reloaded, only
              ;the event is posted)
              reconnect_actions 
                `(,(wevent postback #(reconnect indexpool))))))

(defun comet_setup ()
   ;Change message key based on trigger from app
   (progn 
     (btune:listen #(myapp fun1))
     (io:format "Started comet ~p~n" (list (self)))
     (wait_for_updates)))

(defun wait_for_updates () 
   ;Change message based on trigger from app
   (progn 
     (receive
        (`#(myapp fun1 ,new-val) 
           (progn 
             (wf:update 'triggerval (wf:to_list new-val))  ;Update text field of triggerval
             (wf:flush)))
        (msg 
           (io:format "Comet got: ~p~n" (list msg))))
     ;% Call with ?MODULE: prefix to survive code reloads
     (index1:wait_for_updates)))

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%                                Events
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
(defun event 
  ([#(reconnect indexpool)]
    (progn 
      (wf:update 'triggerval "reconnected")
      ;Start comet because we disconnected/server stopped
      (start_comet)))

  ([`#(,op ,n)]
	 (wf:wire 
      (walert text (++ 
                    (atom_to_list op) 
                    " " 
                    (integer_to_list n))))))
