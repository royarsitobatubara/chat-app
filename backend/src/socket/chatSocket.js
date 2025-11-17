export default function chatSocket(io) {
    io.on("connection", (socket) => {


        socket.on("disconnect", () => {
            console.info('Client out: ', socket.id);
        });
    });
}