import React from "react"
import { Provider } from "react-redux"
import { useSelector, useDispatch } from "react-redux"
import { actions, store } from "./redux"
import { PencilIcon } from "@primer/octicons-react"

const EditButton = () => {
    const is_edit = useSelector((state) => state.is_edit)
    const is_editable = useSelector((state) => state.is_editable)
    const dispatch = useDispatch()
    const handleOnClickEdit = () => dispatch(actions.onClickEdit())

    return (
        <button
            type="button"
            hidden={!(is_editable && !is_edit)}
            className="btn btn-secondary btn-icon"
            onClick={handleOnClickEdit}
        >
            <PencilIcon />
        </button>
    )
}

export default () => (
    <Provider store={store}>
        <EditButton />
    </Provider>
)
