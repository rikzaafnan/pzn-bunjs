import winston from "winston";

const logger = winston.createLogger({
    format:winston.format.json(),
    level:'debug',
    transports: [
        new winston.transports.Console()
    ]
})

logger.info("hellow world")
logger.warn("hellow world")
logger.error("hellow world")