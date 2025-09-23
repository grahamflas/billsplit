import { useEffect, useState } from "react";

import { Menu, MenuButton, MenuItem, MenuItems } from "@headlessui/react";

import NotificationsMenuItem from "./NotificationsMenuItem";

import NotificationsRepository from "../repositories/NotificationsRepository";

import { Notification } from "../types/BaseInterfaces";

interface Props {
  setMobileMenuNotificationsCount?: (count: number | undefined) => void;
}

const NotificationsDropdown = ({ setMobileMenuNotificationsCount }: Props) => {
  const [notificationsCount, setNotificationsCount] = useState<
    number | undefined
  >(undefined);
  const [notifications, setNotifications] = useState<Notification[]>([]);

  const getNotifications = async () => {
    const fetchedNotifications =
      await NotificationsRepository.getNotifications();

    if (fetchedNotifications) {
      setNotificationsCount(fetchedNotifications.count);
      setMobileMenuNotificationsCount?.(fetchedNotifications.count);
      setNotifications([...fetchedNotifications.notifications]);
    }
  };

  useEffect(() => {
    getNotifications();
  }, []);

  const destroyNotification = async (notification: Notification) => {
    const destroyed = await NotificationsRepository.destroy(notification);

    if (destroyed) {
      getNotifications();
    }
  };

  const renderMenuItems = () => {
    if (notifications.length > 0) {
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
    }

    return (
      <MenuItem>
        <div>You don't have any notifications</div>
      </MenuItem>
    );
  };

  return (
    <Menu>
      <MenuButton onClick={getNotifications} data-test={`notifications-button`}>
        <div className="flex gap-2 items-center">
          <span>Notifications</span>
          {notificationsCount && notificationsCount > 0 ? (
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
