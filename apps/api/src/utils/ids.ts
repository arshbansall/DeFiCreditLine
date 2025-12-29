import { ulid } from "ulid";

export const newUserId = () => `usr_${ulid()}`;
export const newEventId = () => `evt_${ulid()}`;