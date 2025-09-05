import Avatar from "react-avatar";

import { User } from "../types/BaseInterfaces";

interface Props {
  size?: number;
  users: User[];
}
const GroupedAvatars = ({ size = 50, users }: Props) => {
  return users.map((user) => {
    const userName = `${user.firstName} ${user.lastName}`;

    return (
      <Avatar
        className="outline outline-white"
        key={user.id}
        name={userName}
        round
        size={String(size)}
      />
    );
  });
};

export default GroupedAvatars;
