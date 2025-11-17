class MessageModel {

  constructor({id, email_user1, email_user2, message, type, isRead, time}) {
    this.id = id,
    this.email_user1 = email_user1,
    this.email_user2 = email_user2,
    this.message = message,
    this.type = type,
    this.isRead = isRead,
    this.time = time
  }

  toJson(){
    return {
        id: this.id,
        email_user1: this.email_user1,
        email_user2: this.email_user2,
        message: this.message,
        type: this.type,
        isRead: this.isRead,
        time: this.time
    }
  }

}
