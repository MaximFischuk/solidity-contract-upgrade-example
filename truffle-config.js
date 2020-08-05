module.exports = {
  // Uncommenting the defaults below 
  // provides for an easier quick-start with Ganache.
  // You can also follow this format for other networks;
  // see <http://truffleframework.com/docs/advanced/configuration>
  // for more details on how to specify configuration options!
  //
  networks: {
  //  development: {
  //    host: "127.0.0.1",
  //    port: 7545,
  //    network_id: "*"
  //  },
   test: {
     host: "127.0.0.1",
     port: 8545,
     network_id: "*"
   }
  },
  //
  compilers: {
    solc: {
      version: "0.6.9", // A version or constraint - Ex. "^0.5.0"
      settings: {
        optimizer: {
          enabled: true,
          runs: 999   // Optimize for how many times you intend to run the code
        },
      }
    }
  }
};
