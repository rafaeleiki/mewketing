class GroupRelationSelector extends React.Component {

  renderRelation(data, key, controllers) {
    let renderedRelation = null;

    if (data.delete && data.id) {
      renderedRelation = this.renderNewRelation(data, key, controllers, 'deleted');
    } else if (data.persist) {
      renderedRelation = this.renderPersistedRelation(data, key, controllers, data.id? '' : 'new');
    } else {
      renderedRelation = this.renderNewRelation(data, key, controllers);
    }

    return renderedRelation;
  }

  renderNewRelation(data, key, controllers, className = '') {
    return (<li key={key} className={`row ${className}`}>
      <label className="relation-label col-sm-1"></label>
      <label className="relation-label col-sm-4">{ data.title }</label>
      { controllers.ADD(key) }
    </li>);
  }

  renderPersistedRelation(data, key, controllers, className) {
    return (<li key={key} className={`row persisted ${className}`}>
      <label className="relation-label col-sm-1">Save</label>
      <label className="relation-label col-sm-4">{ data.title }</label>
      { controllers.DELETE(key) }
    </li>);
  }

  render() {
    const url = `/groups/${this.props.id}/receivers`;
    return (
      <RelationSelector
        id={this.props.id}
        render={(data, key, controllers) => this.renderRelation(data, key, controllers)}
        url={url}
        attributeName="group_receivers"
        entityName="group"
        keyName="receiver_id"
      />
    );
  }
}

GroupRelationSelector.propTypes = {
  id: React.PropTypes.number,
};
