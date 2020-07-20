import React from "react"
import { Tab, Tabs, TabList, TabPanel } from "react-tabs"
import "react-tabs/style/react-tabs.css"
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
        return (
            <Markdown highlight={!is_edit}></Markdown>
        )
    }
    return (
        <div>
            <div className="d-xl-none">
                <MdEditorSm />
            </div>
            <div className="d-none d-xl-flex w-100">
                <MdEditorLg />
            </div>
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

const MdEditorSm = () => (
    <form>
        <Tabs>
            <TabList>
                <Tab>プレビュー</Tab>
                <Tab>編集</Tab>
            </TabList>

            <TabPanel>
                <Markdown highlight={false} />
            </TabPanel>
            <TabPanel>
                <Editor />
            </TabPanel>
        </Tabs>
    </form>
)

const MdEditorLg = () => (
    <div className="row w-100">
        <div className="col-6">
            <p>プレビュー</p>
            <div
                style={{
                    maxHeight: 600,
                    overflowY: "auto",
                }}
            >
                <Markdown highlight={false} />
            </div>
        </div>
        <div className="col-6">
            <p>編集</p>
            <Editor />
        </div>
    </div>
)

export default MdEditor
