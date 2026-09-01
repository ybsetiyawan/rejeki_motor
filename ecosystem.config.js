module.exports = {
  apps: [
    {
      name: "rejeki-motor-api",
      script: "index.js",
      cwd: "./api",
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: "production",
        PORT: 4000
      }
    },
    {
      name: "rejeki-motor-frontend",
      script: "server.js",
      cwd: "./my-app",
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: "production",
        PORT: 8080
      }
    }
  ]
};