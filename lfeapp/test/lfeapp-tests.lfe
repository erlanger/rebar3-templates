(include-lib "lbx/include/lbx.lfe")

(defmodule {{name}}-tests
 (behaviour ltest-system)
 (export all)
 (import
  (from ltest
   (check-failed-is 2)
   (check-wrong-is-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

(defun set-up () (application:ensure_all_started '{{name}}))

(defun tear-down (set-up-result) 'ok)

(deftestcase global-genserver-reg (sres)
 (is-not-equal 'undefined (global:whereis_name '{{name}}_srv)))

(deftestcase local-top-supervisor-reg (sres)
 (is-not-equal 'false (lists:member '{{name}}_sup (registered))))

(deftestcase trigger (sres)
 (is-equal 'trigger_ok
   (progn
     (btune:listen #({{name}} fun1))
     ({{name}}_api:fun1 123)
     (receive
       ((tuple '{{name}} 'fun1 newval) 'trigger_ok)
       (_ 'trigger_not_working))))
 (is-equal '(one 123) ({{name}}_api:get-trigger)))

(deftestgen setup-setup-cleanup
  `#(foreach
     ,(defsetup set-up)
     ,(defteardown tear-down)
     ,(deftestcases 
         global-genserver-reg 
         local-top-supervisor-reg
         trigger
         )))

