import renderMd from "../components/MdEditor/MdEditor"
renderMd();
document.addEventListener('turbolinks:load', renderMd);
document.addEventListener('turbolinks:restore', renderMd);

