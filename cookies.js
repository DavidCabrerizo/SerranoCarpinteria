(function(){
var K="serrano_cookie_consent",TTL=365*864e5,d=document,E="cubic-bezier(.23,1,.32,1)";
function get(){try{var v=JSON.parse(localStorage.getItem(K));if(v&&Date.now()-v.t<TTL)return v}catch(e){}return null}
function save(a){var v={a:a,t:Date.now()};try{localStorage.setItem(K,JSON.stringify(v))}catch(e){}dispatchEvent(new CustomEvent("serrano:consent",{detail:v}));box.classList.remove("on")}
var s=d.createElement("style");s.textContent='.ck{position:fixed;left:max(12px,env(safe-area-inset-left));right:max(12px,env(safe-area-inset-right));bottom:calc(12px + env(safe-area-inset-bottom,0px));z-index:150;max-width:560px;background:#fff;color:#1E3A5F;border-radius:16px;box-shadow:0 0 0 1px rgba(30,58,95,.12),0 24px 60px -20px rgba(18,36,62,.5);padding:20px;font:400 .92rem/1.5 "Hanken Grotesk",system-ui,sans-serif;opacity:0;transform:translateY(12px);visibility:hidden;transition:opacity .3s '+E+',transform .3s '+E+',visibility .3s}.ck.on{opacity:1;transform:none;visibility:visible}.ck h2{margin:0 0 6px;font:700 1.1rem "Bricolage Grotesque",sans-serif}.ck p{margin:0 0 14px}.ck a{color:#8C6A49;font-weight:600}.ck-b{display:flex;gap:8px;flex-wrap:wrap}.ck button{flex:1 1 0;min-width:120px;font:600 .9rem "Hanken Grotesk",sans-serif;padding:11px 14px;border-radius:999px;border:1.5px solid #1E3A5F;background:#fff;color:#1E3A5F;cursor:pointer;transition:transform .16s '+E+',background-color .2s}.ck button:active{transform:scale(.97)}@media(hover:hover){.ck button:hover{background:#FFF8E1}}.ck-c{display:grid;gap:10px;margin:0 0 14px}.ck-c[hidden]{display:none}.ck-c label{display:flex;gap:10px;align-items:center;font-weight:600}.ck-c small{font-weight:400;color:#4A6572}.ck-c button{width:100%}@media(prefers-reduced-motion:reduce){.ck{transition-duration:.01ms}}';
d.head.appendChild(s);
var box=d.createElement("div");box.className="ck";box.setAttribute("role","dialog");box.setAttribute("aria-label","Aviso de cookies");
box.innerHTML='<h2>Cookies</h2><p>Esta web solo usa almacenamiento técnico imprescindible. No usamos cookies de analítica, publicidad ni redes sociales. Puedes aceptar o rechazar las opcionales y cambiar tu elección cuando quieras. <a href="cookies.html">Política de cookies</a></p><div class="ck-c" hidden><label><input type="checkbox" checked disabled> Necesarias <small>Siempre activas</small></label><label><input type="checkbox" id="ck-a"> Analíticas <small>Ahora mismo no usamos ninguna</small></label><button data-a="sav">Guardar preferencias</button></div><div class="ck-b"><button data-a="acc">Aceptar todas</button><button data-a="rej">Rechazar todas</button><button data-a="cfg">Configurar</button></div>';
d.body.appendChild(box);
box.onclick=function(e){var b=e.target.closest("button");if(!b)return;var a=b.dataset.a;
 if(a==="acc")save(true);if(a==="rej")save(false);if(a==="sav")save(d.getElementById("ck-a").checked);
 if(a==="cfg"){var c=box.querySelector(".ck-c");c.hidden=!c.hidden}};
function open(){var v=get();d.getElementById("ck-a").checked=!!(v&&v.a);box.classList.add("on");box.querySelector("button[data-a=acc]").focus()}
d.addEventListener("click",function(e){if(e.target.closest("[data-cookies]"))open()});
window.SerranoConsent={get:get,open:open};
if(!get())setTimeout(function(){box.classList.add("on")},400);
})();
