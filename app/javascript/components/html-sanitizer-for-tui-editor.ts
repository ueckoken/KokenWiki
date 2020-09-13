import Dompurify from "dompurify"

const customHTMLSanitizer = (domstring: string): string =>
    Dompurify.sanitize(domstring, {
        FORBID_TAGS: [
            "script",
            "iframe",
            "textarea",
            "form",
            "button",
            "select",
            "input",
            "meta",
            "style",
            "link",
            "title",
            "embed",
            "object",
        ],
        FORBID_ATTR: ["class"],
    })

export default customHTMLSanitizer
