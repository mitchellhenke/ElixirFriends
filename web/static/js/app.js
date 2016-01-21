// import "phoenix_html"
import {Socket} from "phoenix"
import React from 'react'
import ReactDOM from 'react-dom'
import ReactCSSTransitionGroup from 'react-addons-css-transition-group'
import classNames from 'classnames'
import moment from 'moment'
let App = {
}
let PostList = React.createClass({
  getInitialState() {
    return {
      posts: [
      ]
    }
  },
  componentDidMount() {
    this.subscribeToNewPosts();
  },
  subscribeToNewPosts() {
    let socket = new Socket("/socket")
    socket.connect()
    let channel = socket.channel("posts:new", {})
    channel.join().receive("ok", chan => {
      console.log("joined")
    })
    channel.on("new:post", post => {
      console.log(post)
    })
  },
  render() {
    return(
        <div className="ui grid stackable">
        {this.state.posts.map(function(post) {
                                               return <Post imageUrl={post.image_url} username={post.username} insertedAt={post.inserted_at} content={post.content} />
                                             })}
      </div>
      )
  }
})

let Post = React.createClass({
  render() {
    return(
    <div className="four wide column">
        <div className="ui card">
          <div className="image">
            <img src={this.props.imageUrl} />
          </div>
          <div className="content">
            <div className="header">
              {this.props.username}
            </div>
            <div className="meta">
              <span className="date">{this.props.insertedAt}</span>
            </div>
            <div className="description">
              {this.props.content}
            </div>
          </div>
        </div>
      </div>
      )
  }
})

window.onload = () => {
  let element = document.getElementById("app")
  ReactDOM.render(<PostList />, element)
}

export default App
