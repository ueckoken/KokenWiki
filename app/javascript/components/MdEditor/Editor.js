import React, { Fragment, useEffect, useRef, useState } from "react"
import { useSelector, useDispatch } from "react-redux"
import { actions } from "../redux"
import Editor from "@toast-ui/editor"

export default () => {
    const markdown = useSelector((state) => state.markdown)
    const dispatch = useDispatch()
    const handleChangeText = (newValue) =>
        dispatch(actions.changeText(newValue))
    const rootEl = useRef(null)
    const [tuiEditor, setTuiEditor] = useState(null)
    useEffect(() => {
        if (rootEl.current === null) {
            return
        }
        const inst = new Editor({
            el: rootEl.current,
            initialValue: markdown,
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
        console.log(inst.minHeight())
        console.log(inst.height())
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
