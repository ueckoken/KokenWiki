import React, { Fragment } from "react"
import { connect } from "react-redux"
import { actions } from "./redux"
import MonacoEditor from "react-monaco-editor"

export const Editor = ({ markdown, handleChangeText }) => (
    <Fragment>
        <MonacoEditor
            value={markdown}
            onChange={newValue => handleChangeText(newValue)}
            language="markdown"
            height="600"
            options={{
                wordWrap: "on"
            }}
        />
        <textarea hidden value={markdown} name="page[content]" />
    </Fragment>
)

export default connect(
    state => ({
        markdown: state.markdown
    }),
    {
        handleChangeText: actions.changeText
    }
)(Editor)
