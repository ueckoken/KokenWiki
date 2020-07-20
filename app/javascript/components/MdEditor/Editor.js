import React, { Fragment } from "react"
import { useSelector, useDispatch } from "react-redux"
import { actions } from "../redux"
import MonacoEditor from "react-monaco-editor"

export default () => {
    const markdown = useSelector((state) => state.markdown)
    const dispatch = useDispatch()
    const handleChangeText = (newValue) =>
        dispatch(actions.changeText(newValue))
    return (
        <Fragment>
            <MonacoEditor
                value={markdown}
                onChange={handleChangeText}
                language="markdown"
                height="600"
                options={{
                    wordWrap: "on",
                }}
            />
            <textarea hidden readOnly value={markdown} name="page[content]" />
        </Fragment>
    )
}
