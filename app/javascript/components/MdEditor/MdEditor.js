import marked from 'marked';
import PropTypes from 'prop-types'
import React from 'react'
import ReactDOM from 'react-dom'
import * as escape from 'escape-html';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import { hidden } from 'ansi-colors';
import { Provider, connect } from 'react-redux';
import { createStore } from 'redux';
import Markdown from "./Markdown";
import Editor from "./Editor";
import { mapStateToProps, mapDispatchToProps } from "./connector";
import MdEditorReducer from "./MdEditorReducer"
import Actions from "./Actions";


class MdEditor extends React.Component {
    
    constructor(props) {
        super(props);
    }
    componentDidMount() {
        const root = document.getElementById("mdEditor");
        this.props.handleSetContent(root.getAttribute("markdown"));
    }
    render() {
        return (
            <React.Fragment>
                <div hidden={this.props.is_edit}>
                    <button type="button" className="btn btn-secondary" onClick={this.props.handleOnClickEdit}>編集</button>
                    <Markdown></Markdown>
                </div>
                <div hidden={!this.props.is_edit}>
                    <div className="d-lg-none">
                        <MdEditorSm>

                        </MdEditorSm>
                    </div>
                    <div className="d-none d-lg-flex width100">
                        <MdEditorLg>

                        </MdEditorLg>
                    </div>
                    <button type="button" className="btn btn-secondary" onClick={this.props.handleOnClickCancel}>破棄</button>
                    <input type="submit" value="保存" className="btn btn-primary" style={{ float: "right" }} hidden={!this.props.is_changed}></input>
                </div>
            </React.Fragment>
        );
    }
    /*onChangeText(e) {
        this.setState({
            markdown: e.target.value,
            is_changed: true
        });
    }*/
}
MdEditor = connect(mapStateToProps, mapDispatchToProps)(MdEditor)

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
                        <Markdown></Markdown>
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
                            <Markdown></Markdown>
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

let store = createStore(MdEditorReducer);

export default () => {
    ReactDOM.render(
        <Provider store={store}>
            <MdEditor />
        </Provider>,
        document.getElementById("mdEditor")
    )
}
//export default MdEditor;