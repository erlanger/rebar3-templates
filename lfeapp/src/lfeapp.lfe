(include-lib "lbx/include/lbx.lfe")
(include-lib "lbx/include/mkapp.lfe")

(application {{name}} {{name}}_sup)

(supervisor {{name}}_sup
  ((worker {{name}}_srv)))

(genserver {{name}}_srv
  ((state-match (map 'key1 val1 'key2 val2 'trigger trg))
   ;Update key1 with new value
   (call fun1 (arg1) 
     "Set `key1` in the _State_ to `arg1`. It also triggers if
      `arg1` has a different value than the current one."
     (tuple 'reply arg1 (maps:update 'key1 arg1 (state))))

   ;The variables matched in state-match are available
   (call get-trigger () 
     "Call. Returns the value of the `trigger` key in the _State_."
     (tuple 'reply trg (state)))

   ;Update key1 with original value
   (cast reset () 
     "Cast. Resets `key1` to the value `'one`."
     (tuple 'noreply (maps:update 'key1 'one (state))))

   ;Set trigger key on map to value
   (cast set-trigger (value) 
     "Cast. Sets the `trigger` key to `value`."
     (tuple 'noreply (maps:update 'trigger value (state))))

   ;Initialize state 
   (init `#(ok #M(key1 one key2 two trigger none)))

   ;Trigger if key1 changes
   (trigger 'fun1 (map 'key1 oldval) (map 'key1 newval) (!= oldval newval)
     (progn
      ({{name}}_api:set-trigger (list oldval newval))
      (format "fun1 changed key1 from ~p to ~p~nstate:" 
       (list oldval newval))
      (btune:bcast #(myapp fun1) `#(myapp fun1 ,newval)))))

  ;print generated module and register {{name}}_srv globally
  (print global #(api-module {{name}}_api))
  )
