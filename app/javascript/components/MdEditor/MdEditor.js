import marked, { options } from 'marked';
import PropTypes from 'prop-types'
import React from 'react'
import ReactDOM from 'react-dom'
import * as escape from 'escape-html';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import { hidden } from 'ansi-colors';
import { connect } from 'react-redux';
import Markdown from "./Markdown";
import Editor from "./Editor";
import Actions from "./Actions";

class MdEditor extends React.Component {
    render() {
        if (!this.props.is_edit) {
            return (
                <div>
                    <button type="button" hidden={!this.props.is_editable} className="btn btn-secondary" onClick={this.props.handleOnClickEdit}>編集</button>
                    <Markdown highlight={!this.props.is_edit}></Markdown>
                </div>
            );
        }
        return (
            <div>
                <div className="d-xl-none">
                    <MdEditorSm />
                </div>
                <div className="d-none d-xl-flex width100">
                    <MdEditorLg />
                </div>
                <div>
                    <label>閲覧可能グループ</label>
                    <select value={this.props.readable_group_id} name="page[readable_group_id]" className="form-control" onChange={this.props.handleChangeReadableGroup}>
                        <option key={0} value={0}>部員全員</option>
                        
                        {this.props.usergroups.map((usergroup,i)=>{
                            return <option value={usergroup.id} key={i+1}>{usergroup.name}</option>
                        })}
                    </select>
                </div>
                <div>
                    <label>編集可能グループ</label>
                    <select value={this.props.editable_group_id} name="page[editable_group_id]" className="form-control" onChange={this.props.handleChangeEditableGroup}>
                        <option value={0}>部員全員</option>
                        

                        {this.props.usergroups.map((usergroup,i)=>{
                            return <option value={usergroup.id} key={i+1}>{usergroup.name}</option>
                        })}
                    </select>
                </div>
                <div className="form-check">
                    <input type="checkbox" className="form-check-input" checked={this.props.is_draft} onChange={this.props.handleOnClickIsDraft}/>
                    <label className="form-check-label">下書き</label>
                    <input type="hidden" name="page[is_draft]" value={this.props.is_draft} />
                </div>
                <div className="form-check">
                    <input type="checkbox" className="form-check-input" checked={this.props.is_public} onChange={this.props.handleOnClickIsPublic}/>
                    <label className="form-check-label">一般公開</label>
                    <input type="hidden" name="page[is_public]" value={this.props.is_public} />
                </div>
                <button type="button" className="btn btn-secondary" onClick={this.props.handleOnClickCancel}>破棄</button>
                <input type="submit" value="保存" className="btn btn-primary" style={{ float: "right" }} hidden={!this.props.is_changed}></input>
            </div>
        );
    }
    /*onChangeText(e) {
        this.setState({
            markdown: e.target.value,
            is_changed: true
        });
    }*/
}

class MdEditorSm extends React.Component{

    constructor(props) {
        super(props);
    }
    render() {
        return (
            <form>
                <Tabs
                    onSelect={this.props.handleChangeTab}
                    selectedIndex={this.props.tabIndex}
                >

                    <TabList>
                        <Tab>プレビュー</Tab>
                        <Tab>編集</Tab>
                    </TabList>

                    <TabPanel>
                        <Markdown highlight={false}></Markdown>
                    </TabPanel>
                    <TabPanel>
                        <Editor>
                        </Editor>
                    </TabPanel>

                </Tabs>
            </form>
        );
    }
}
class MdEditorLg extends React.Component {

    constructor(props) {
        super(props);
    }
    render() {
        return (
            <div className="row width100">
                <div className="col-6">
                    <Tabs>
                        <TabList>
                            <Tab>プレビュー</Tab>
                        </TabList>

                        <TabPanel>
                            <Markdown highlight={false}></Markdown>
                        </TabPanel>
                    </Tabs>
                </div>
                <div className="col-6">

                    <Tabs>
                        <TabList>
                            <Tab>編集</Tab>
                        </TabList>
                        <TabPanel>
                            <Editor>
                            </Editor>
                        </TabPanel>

                    </Tabs>
                </div>
            </div>
        );
    }
}

export default connect((state) => ({
    usergroups: state.usergroups,
    tabIndex: state.tabIndex,
    is_edit: state.is_edit,
    is_changed: state.is_changed,
    is_editable: state.is_editable,
    readable_group_id: state.readable_group_id,
    editable_group_id: state.editable_group_id,
    is_draft: state.is_draft,
    is_public: state.is_public,
}), {
    handleChangeTab: Actions.changeTab,
    handleOnClickEdit: Actions.onClickEdit,
    handleOnClickCancel: Actions.onClickCancel,
    handleOnClickIsDraft: Actions.onClickIsDraft,
    handleOnClickIsPublic: Actions.onClickIsPublic,
    handleChangeReadableGroup: Actions.changeReadableGroup,
    handleChangeEditableGroup: Actions.changeEditableGroup,
})(MdEditor);