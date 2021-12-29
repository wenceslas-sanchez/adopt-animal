
module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 7545,
            network_id: "*", // match any network
        },
        develop: {
            host: "localhost",
            port: 7545,
            network_id: "*", // match any network
        },
        mynetwork: {
            host: "localhost",
            port: 7545,
            network_id: "*" // match any network
        },
    },
    compilers: {
        solc: {
            version: "0.8.11"
        }
    }
}