import React from "react"
import { connect } from "react-redux"
import TextareaAutosize from "react-autosize-textarea"
import { actions } from "./redux"

export const Editor = ({ markdown, handleChangeText }) => (
    <div>
        <TextareaAutosize
            className="form-control"
            row={5}
            value={markdown}
            onChange={e => handleChangeText(e.target.value)}
            name="page[content]"
        />
    </div>
)

export default connect(
    state => ({
        markdown: state.markdown
    }),
    {
        handleChangeText: actions.changeText
    }
)(Editor)
