import winston from 'winston';
import { config } from 'dotenv';
config();

const transports = [
  ...(process.env.NODE_ENV !== 'production'
    ? [new winston.transports.Console()]
    : []),
  new winston.transports.File({ filename: 'activity.log' })
];

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    winston.format.printf(info => `[${info.timestamp}] [${info.level.toUpperCase()}]: ${info.message}`)
  ),
  transports
});

export default logger;
