import{d as _,u as d,a as h,c as m,b as p,r as u,o as a,e as n,f as t,t as o,g as l,F as f,h as g,n as v,i as y,j as x,k as b,l as k,m as N,_ as P}from"./index-CNG3SxKq.js";import{N as w}from"./NoteDisplay-WyCkNgfF.js";const V={class:"m-4"},L={class:"mb-10"},S={class:"text-4xl font-bold mt-2"},T={class:"opacity-50"},z={class:"text-lg"},B={class:"font-bold flex gap-2"},D={class:"opacity-50"},H=t("div",{class:"flex-auto"},null,-1),j={key:0,class:"border-gray-400/50 mb-8"},C=_({__name:"PresenterPrint",setup(F){d(`
@page {
  size: A4;
  margin-top: 1.5cm;
  margin-bottom: 1cm;
}
* {
  -webkit-print-color-adjust: exact;
}
html,
html body,
html #app,
html #page-root {
  height: auto;
  overflow: auto !important;
}
`),h({title:`Notes - ${m.title}`});const i=p(()=>u.map(s=>{var r;return(r=s.meta)==null?void 0:r.slide}).filter(s=>s!==void 0&&s.noteHTML!==""));return(s,r)=>(a(),n("div",{id:"page-root",style:v(l(y))},[t("div",V,[t("div",L,[t("h1",S,o(l(m).title),1),t("div",T,o(new Date().toLocaleString()),1)]),(a(!0),n(f,null,g(i.value,(e,c)=>(a(),n("div",{key:c,class:"flex flex-col gap-4 break-inside-avoid-page"},[t("div",null,[t("h2",z,[t("div",B,[t("div",D,o(e==null?void 0:e.no)+"/"+o(l(x)),1),b(" "+o(e==null?void 0:e.title)+" ",1),H])]),k(w,{"note-html":e.noteHTML,class:"max-w-full"},null,8,["note-html"])]),c<i.value.length-1?(a(),n("hr",j)):N("v-if",!0)]))),128))])],4))}}),E=P(C,[["__file","/Users/francisyzy/dev/hackertools_materials/self-hosting/src/node_modules/@slidev/client/internals/PresenterPrint.vue"]]);export{E as default};
