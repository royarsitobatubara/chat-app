export default function chatSocket(io) {
    const onlineUsers = {};
    
    io.on("connection", (socket) => {

        socket.on("register", async (email) => {
            onlineUsers[email] = socket.id;
            const pendingMessages = await MessageModel.get({ data: { to: email } });
            if (pendingMessages && pendingMessages.length > 0) {
                pendingMessages.forEach(msg => {
                    io.to(socket.id).emit("receive_message", msg);
                });
                await MessageModel.delete({ data: { to: email } });
            }
            logger.info(`ONLINE ${email}: ${socket.id}`);
        });


        socket.on("send_message", async (data) => {
            const targetSocket = onlineUsers[data.to];
            if (targetSocket) {
                io.to(targetSocket).emit("receive_message", data);
            } else {
                await MessageModel.insert({ data });
            }
        });


        socket.on("disconnect", () => {
            for (let uid in onlineUsers) {
                if (onlineUsers[uid] === socket.id) {
                    delete onlineUsers[uid];
                    break;
                }
            }
        });
        
    });
}
