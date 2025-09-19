import { useState } from "react";

import { Menu, MenuButton, MenuItem, MenuItems } from "@headlessui/react";

import NotificationsMenuItem from "./NotificationsMenuItem";

import NotificationsRepository from "../repositories/NotificationsRepository";

import { Notification } from "../types/BaseInterfaces";

interface Props {
  notifications: Notification[];
}

const NotificationsDropdown = ({ notifications }: Props) => {
  const [notificationsCount, setNotificationsCount] = useState(
    notifications.length
  );

  const destroyNotification = async (notification: Notification) => {
    const destroyed = await NotificationsRepository.destroy(notification);

    if (destroyed) {
      setNotificationsCount((prevCount) => prevCount - 1);
    }
  };

  const renderMenuItems = () => {
    return notifications.map((notification) => {
      return (
        <MenuItem key={notification.id}>
          <NotificationsMenuItem
            destroyNotification={destroyNotification}
            notification={notification}
          />
        </MenuItem>
      );
    });
  };

  return (
    <Menu>
      <MenuButton data-test={`notifications-button`}>
        <div className="flex gap-2 items-center">
          <span>Notifications</span>
          {notificationsCount > 0 ? (
            <span className="w-6 h-6 rounded-full flex justify-center items-center bg-rose-500 p-2">
              {notificationsCount}
            </span>
          ) : null}
        </div>
      </MenuButton>

      <MenuItems
        transition
        anchor="bottom end"
        data-test={`notifications-dropdown`}
        className="shadow-2xl flex flex-col gap-2 origin-top-right rounded-xl bg-white p-4 transition duration-100 ease-out [--anchor-gap:--spacing(1)] focus:outline-none data-closed:scale-95 data-closed:opacity-0"
      >
        {renderMenuItems()}
      </MenuItems>
    </Menu>
  );
};

export default NotificationsDropdown;
