/* print.js — centralized print handler (no inline JS) */
(function(){
  function onClick(e){
    var btn = e.target && e.target.closest ? e.target.closest("[data-print]") : null;
    if(!btn) return;
    e.preventDefault();
    try{ window.print(); }catch(_e){}
  }
  if(document.readyState === "loading"){
    document.addEventListener("DOMContentLoaded", function(){
      document.addEventListener("click", onClick, true);
    });
  } else {
    document.addEventListener("click", onClick, true);
  }
})();
