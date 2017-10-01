class VarsTable extends React.Component {

    constructor(props) {
        super(props);
        let vars = this.getVars(props.text);
        this.state = {
            vars,
            text: props.text,
            values: props.values,
        };
    }

    getVars(text = this.state.text) {
        let index = 0;
        let vars = [].concat(this.props.defaultVars);
        while (index >= 0) {
            let { variable, newIndex } = this.findVar(text, index);
            index = newIndex;
            if (variable) {
                vars.push(variable);
            }
        }
        return vars;
    }

    findVar(text, index) {
        let begin = text.indexOf('{{', index);
        let variable, newIndex;
        if (begin >= 0) {
            begin += 2; // skips {{
            let end = text.indexOf('}}', begin);
            variable = text.substr(begin, end - begin);
            newIndex = end + 2;
        } else {
            newIndex = -1;
        }
        return { variable, newIndex };
    }

    addDataLine() {
        let { values, vars } = this.state;
        let dataLine = {};
        vars.forEach(variable => dataLine[variable] = '');
        values.push(dataLine);
        this.setState({ values });
    }

    renderLine(dataLine, key, vars) {
        return (
            <tr key={key}>{
                vars.map((variable, index) =>
                    (<td key={index}>
                        <input type="text"
                               name={ `vars_values[${key}][${variable}]` }
                               defaultValue={ dataLine[variable] } />
                    </td>)
                )
            }</tr>
        );
    }

    render() {
        let { text, values, vars } = this.state;
        return (
            <div>
                <textarea defaultValue={text}
                          name="email[body]"
                          id="email_body"
                          onChange={(event) => this.setState({ text: event.target.value })}>
                </textarea>
                <table>
                    <thead>
                        <tr>{ vars.map((variable, i) => <th key={i}>{ variable }</th>) }</tr>
                    </thead>
                    <tbody>
                        { values.map((dataLine, index) => this.renderLine(dataLine, index, vars)) }
                    </tbody>
                </table>
                {
                    vars.map((variable, i) =>
                        <input type="hidden" name={ `vars[${i}]` } key={i} value={variable} />
                    )
                }
                <button type="button" onClick={(event) => this.addDataLine()}>Add</button>
                <button type="button" onClick={(event) => this.setState({ vars: this.getVars() })}>Refresh</button>
            </div>
        );
    }

}

VarsTable.propTypes = {
    text: React.PropTypes.string,
    values: React.PropTypes.array,
    defaultVars: React.PropTypes.array
};
