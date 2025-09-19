import { Menu, MenuButton, MenuItem, MenuItems } from "@headlessui/react";

import NotificationsMenuItem from "./NotificationsMenuItem";

import { Notification } from "../types/BaseInterfaces";

interface Props {
  notifications: Notification[];
}

const NotificationsDropdown = ({ notifications }: Props) => {
  const renderMenuItems = () => {
    return notifications.map((notification) => {
      return (
        <MenuItem>
          <NotificationsMenuItem notification={notification} />
        </MenuItem>
      );
    });
  };

  return (
    <Menu>
      <MenuButton data-test={`notifications-button`}>
        <div className="flex gap-2 items-center">
          <span>Notifications</span>
          {notifications.length > 0 ? (
            <span className="w-6 h-6 rounded-full flex justify-center items-center bg-rose-500 p-2">
              {notifications.length}
            </span>
          ) : null}
        </div>
      </MenuButton>

      <MenuItems
        transition
        anchor="bottom end"
        data-test={`notifications-dropdown`}
        className="flex flex-col gap-2 origin-top-right rounded-xl bg-white p-4 transition duration-100 ease-out [--anchor-gap:--spacing(1)] focus:outline-none data-closed:scale-95 data-closed:opacity-0"
      >
        {renderMenuItems()}
      </MenuItems>
    </Menu>
  );
};

export default NotificationsDropdown;
