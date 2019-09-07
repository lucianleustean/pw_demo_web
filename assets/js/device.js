let Device = {

  init(socket, element) { if (!element) { return }
    socket.connect()
    this.onReady(socket)
  },

  onReady(socket) {
    let msgContainer  = document.getElementById("msg-container")
    let msgInput      = document.getElementById("msg-input")
    let sendButton    = document.getElementById("msg-submit")
    let deviceChannel = socket.channel("channels:devices", {})

    sendButton.addEventListener("click", e => {
      let payload = {message: msgInput.value, source: "browser"}
      deviceChannel.push("message", payload)
                   .receive("error", e => console.log(e))
      msgInput.value = ""
    })

    deviceChannel.on("message", (resp) => {
      this.renderMessage(msgContainer, resp)
    })

    deviceChannel.join()
      .receive("ok", resp => console.log("joined devices channel", resp) )
      .receive("error", reason => console.log("join failed", reason))
  },

  renderMessage(msgContainer, {message, source}) {
    let template = document.createElement("div")
    template.innerHTML = `<b>${source}</b>: ${message}`

    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  }
}

export default Device
