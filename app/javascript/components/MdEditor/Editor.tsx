import React, { FC, Fragment, useEffect, useRef, useState } from "react"
import { useDispatch } from "react-redux"
import { actions, useTypedSelector } from "../redux"
import ToastUIEditor from "@toast-ui/editor"
import customHTMLSanitizer from "../html-sanitizer-for-tui-editor"

const Editor: FC<{}> = () => {
    const markdown = useTypedSelector((state) => state.markdown)
    const dispatch = useDispatch()
    const handleChangeText = (newValue: string) =>
        dispatch(actions.changeText(newValue))
    const rootEl = useRef<HTMLDivElement>(null)
    const [tuiEditor, setTuiEditor] = useState<ToastUIEditor | null>(null)
    useEffect(() => {
        if (rootEl.current === null) {
            return
        }
        const inst = new ToastUIEditor({
            el: rootEl.current,
            initialValue: markdown,
            customHTMLSanitizer: customHTMLSanitizer,
            previewStyle: "vertical",
            minHeight: "400px",
            height: "600px",
            language: "ja-JP",
            events: {
                change: () => {
                    const newMarkdownText = inst.getMarkdown()
                    handleChangeText(newMarkdownText)
                },
            },
        })
        setTuiEditor(inst)
        return () => {
            tuiEditor?.remove()
        }
    }, [rootEl])
    useEffect(() => {
        if (tuiEditor === null) {
            return
        }
        tuiEditor.setMarkdown(markdown)
    }, [tuiEditor])
    return (
        <Fragment>
            <div ref={rootEl} />
            <textarea hidden readOnly value={markdown} name="page[content]" />
        </Fragment>
    )
}

export default Editor
