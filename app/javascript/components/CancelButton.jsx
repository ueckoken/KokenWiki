import React from "react"
import { Provider } from "react-redux"
import { useSelector, useDispatch } from "react-redux"
import { actions, store } from "./redux"
import { XIcon } from "@primer/octicons-react"

const CancelButton = () => {
    const is_edit = useSelector((state) => state.is_edit)
    const dispatch = useDispatch()
    const handleOnClickCancel = () => dispatch(actions.onClickCancel())

    return (
        <button
            type="button"
            hidden={!is_edit}
            className="btn btn-secoudary btn-icon"
            onClick={handleOnClickCancel}
        >
            <XIcon />
        </button>
    )
}

export default () => (
    <Provider store={store}>
        <CancelButton />
    </Provider>
)
