import React, { memo, useRef, useEffect, useState, FC } from "react"
import Viewer from "@toast-ui/editor/dist/toastui-editor-viewer"
import customHTMLSanitizer from "./html-sanitizer-for-tui-editor"

type Props = {
    markdown: string
}

const Markdown: FC<Props> = ({ markdown }) => {
    const rootEl = useRef<HTMLDivElement>(null)
    const [viewerInst, setViewerInst] = useState<Viewer | null>(null)
    useEffect(() => {
        if (rootEl.current === null) {
            return
        }
        const inst = new Viewer({
            el: rootEl.current,
            initialValue: markdown,
            customHTMLSanitizer: customHTMLSanitizer,
        })
        setViewerInst(inst)
        return () => {
            viewerInst?.remove()
        }
    }, [rootEl])
    useEffect(() => {
        if (viewerInst === null) {
            return
        }
        viewerInst.setMarkdown(markdown)
    }, [viewerInst, markdown])
    return <div ref={rootEl} />
}
export default memo(Markdown)
