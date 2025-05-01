import React, { memo, useRef, useEffect, useState, FC } from "react"
import Viewer from "@toast-ui/editor/dist/toastui-editor-viewer"
import customHTMLSanitizer from "./html-sanitizer-for-tui-editor"
import { CustomHTMLRenderer } from "@toast-ui/editor"

const customImageRenderer: CustomHTMLRenderer = (_, { origin }) => {
    const result = origin!()
    if (result === null) {
        return null
    }
    if (result instanceof Array) {
        for (const token of result) {
            if (token.type !== "openTag") {
                continue
            }
            if (token.attributes === undefined) {
                token.attributes = {}
            }
            token.attributes.loading = "lazy"
        }
        return result
    }
    if (result.type !== "openTag") {
        return result
    }
    if (result.attributes === undefined) {
        result.attributes = {}
    }
    result.attributes.loading = "lazy"
    return result
}

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
            // type for customHTMLRenderer is wrong
            // ref: https://github.com/nhn/tui.editor/issues/1064
            customHTMLRenderer: {
                image: customImageRenderer,
            } as any,
        })
        setViewerInst(inst)
        return () => {
            viewerInst?.destroy()
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
