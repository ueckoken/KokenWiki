import React from "react"
import { Provider } from "react-redux"
import { useSelector } from "react-redux"
import { selectors, store } from "./redux"
import { CheckIcon } from "@primer/octicons-react"

const SaveButton = ({ formId }) => {
    const is_edit = useSelector((state) => state.is_edit)
    const is_changed = useSelector(selectors.isChanged)

    return (
        <button
            type="submit"
            hidden={!is_edit}
            disabled={!is_changed}
            className="btn btn-primary btn-icon"
            form={formId}
        >
            <CheckIcon />
        </button>
    )
}

export default ({ formId }) => (
    <Provider store={store}>
        <SaveButton formId={formId} />
    </Provider>
)
