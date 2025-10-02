import { useEffect, useState } from "react";

import { CiUser } from "react-icons/ci";
import { RxHamburgerMenu } from "react-icons/rx";

import NotificationsDropdown from "./NotificationsDropdown";

import NotificationsRepository from "../repositories/NotificationsRepository";

import { User } from "../types/BaseInterfaces";

interface Props {
  currentUser: User | undefined;
  editPath: string;
  handleDemoModalButtonClick: () => void;
  hasArchivedGroups: boolean;
  logoutPath: string;
  rootPath: string;
  signInPath: string;
  signUpPath: string;
}

const MobileNav = ({
  currentUser,
  editPath,
  handleDemoModalButtonClick,
  hasArchivedGroups,
  logoutPath,
  signInPath,
  signUpPath,
}: Props) => {
  const [displayMenu, setDisplayMenu] = useState(false);
  const [mobileMenuNotificationsCount, setMobileMenuNotificationsCount] =
    useState<number | undefined>(undefined);

  const getNotifications = async () => {
    const fetchedNotifications =
      await NotificationsRepository.getNotifications();

    if (fetchedNotifications) {
      setMobileMenuNotificationsCount(fetchedNotifications.count);
    }
  };

  useEffect(() => {
    getNotifications();
  }, []);

  const renderGuestActions = () => {
    if (!currentUser) {
      return (
        <>
          <a
            className="rounded-3xl px-3 py-1 text-white hover:text-indigo-200 text-indigo-500 text-center"
            href={signInPath}
          >
            <div className="flex gap-1">
              <CiUser size={25} />
              Sign in
            </div>
          </a>
          <a
            className="rounded-xl px-5 py-1 text-white bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-center"
            href={signUpPath}
          >
            Sign up
          </a>
        </>
      );
    }
  };

  const renderLoggedInActions = () => {
    if (currentUser) {
      return (
        <>
          <button
            className="rounded-xl px-5 py-1 text-white bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-center"
            onClick={handleDemoModalButtonClick}
          >
            About this demo
          </button>
          <NotificationsDropdown
            setMobileMenuNotificationsCount={setMobileMenuNotificationsCount}
          />

          <a href="/groups">Active Groups</a>

          {hasArchivedGroups && <a href="/groups/archived">Archived Groups</a>}

          <a href={editPath}>Edit Profile</a>

          <a data-turbo-method="delete" href={logoutPath}>
            Sign out
          </a>
        </>
      );
    }
  };

  return (
    <div className="block sm:hidden mr-4">
      <button onClick={() => setDisplayMenu(!displayMenu)}>
        <div className="flex gap-1">
          {mobileMenuNotificationsCount ? (
            <span className="w-6 h-6 rounded-full flex justify-center items-center bg-rose-500 p-2">
              {mobileMenuNotificationsCount}
            </span>
          ) : null}

          <RxHamburgerMenu size={25} />
        </div>
      </button>

      {displayMenu && (
        <div className="flex flex-col items-end gap-6 bg-gray-800 text-white fixed left-0 top-0 w-screen h-fit p-4">
          <button onClick={() => setDisplayMenu(false)}>
            <RxHamburgerMenu size={25} />
          </button>

          {renderGuestActions()}

          {renderLoggedInActions()}
        </div>
      )}
    </div>
  );
};

export default MobileNav;
