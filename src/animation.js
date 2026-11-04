var stage=document.getElementById("stage"),intro=document.getElementById("intro"),ht=document.getElementById("ht");
var rm=matchMedia("(prefers-reduced-motion:reduce)").matches;
function cl(x){return Math.max(0,Math.min(1,x))}
function upd(){
 var r=intro.getBoundingClientRect(),p=rm?1:cl(-r.top/(r.height-innerHeight));
 stage.style.setProperty("--d",cl(p/.45));stage.style.setProperty("--z",cl((p-.3)/.7));
 var t=cl((p-.68)/.22);ht.style.setProperty("--t",t);ht.classList.toggle("on",t>.5);
}
addEventListener("scroll",upd,{passive:true});addEventListener("resize",upd);upd();
