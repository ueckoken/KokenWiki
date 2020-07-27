import React from "react"
import { useSelector, useDispatch } from "react-redux"
import Markdown from "./Markdown"
import Editor from "./Editor"
import { actions } from "../redux"

const MdEditor = () => {
    const usergroups = useSelector((state) => state.usergroups)
    const readable_group_id = useSelector((state) => state.readable_group_id)
    const editable_group_id = useSelector((state) => state.editable_group_id)
    const is_edit = useSelector((state) => state.is_edit)

    const dispatch = useDispatch()
    const handleChangeReadableGroup = (e) =>
        dispatch(actions.changeReadableGroup(Number(e.target.value)))
    const handleChangeEditableGroup = (e) =>
        dispatch(actions.changeEditableGroup(Number(e.target.value)))

    if (!is_edit) {
        return <Markdown />
    }
    return (
        <div>
            <Editor />
            <div>
                <label>閲覧可能グループ</label>
                <select
                    value={readable_group_id}
                    name="page[readable_group_id]"
                    className="form-control"
                    onChange={handleChangeReadableGroup}
                >
                    <option key={0} value={0}>
                        部員全員
                    </option>
                    {usergroups.map((usergroup, i) => (
                        <option value={usergroup.id} key={i + 1}>
                            {usergroup.name}
                        </option>
                    ))}
                </select>
            </div>
            <div>
                <label>編集可能グループ</label>
                <select
                    value={editable_group_id}
                    name="page[editable_group_id]"
                    className="form-control"
                    onChange={handleChangeEditableGroup}
                >
                    <option value={0}>部員全員</option>
                    {usergroups.map((usergroup, i) => (
                        <option value={usergroup.id} key={i + 1}>
                            {usergroup.name}
                        </option>
                    ))}
                </select>
            </div>
        </div>
    )
}

export default MdEditor
