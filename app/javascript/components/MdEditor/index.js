import React, { useEffect } from "react"
import { Provider } from "react-redux"
import { store, actions } from "../redux"
import MdEditor from "./MdEditor"

export default ({
    title,
    markdown,
    usergroups,
    is_editable,
    is_destroyable,
    readable_group_id,
    editable_group_id,
    parent_page_id,
    next_parent_pages,
}) => {
    useEffect(() => {
        store.dispatch(
            actions.setContent({
                title,
                markdown,
                usergroups,
                is_editable,
                is_destroyable,
                readable_group_id,
                editable_group_id,
                parent_page_id,
                next_parent_pages,
            })
        )
    }, [
        title,
        markdown,
        usergroups,
        is_editable,
        is_destroyable,
        readable_group_id,
        editable_group_id,
        parent_page_id,
        next_parent_pages,
    ])
    return (
        <Provider store={store}>
            <MdEditor />
        </Provider>
    )
}
