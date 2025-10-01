import { formatCurrency } from "../utils/formatCurrency";

import { Balances, User, UserBalance } from "../types/BaseInterfaces";

interface Props {
  balances: Balances;
  currentUser: User;
  isForSettlement?: boolean;
}

const BalancesData = ({
  balances,
  currentUser,
  isForSettlement = false,
}: Props) => {
  const currentUserBalance = balances.userBalances.find(
    (userBalance) => userBalance.userId === currentUser.id
  );

  const otherUserBalances = balances.userBalances.filter(
    (userBalance) => userBalance.userId !== currentUser.id
  );

  const oweOrReceive = (userBalance: UserBalance) => {
    const displayUserBalance = formatCurrency(userBalance.balance);

    if (userBalance.balance > 0) {
      if (isForSettlement) {
        return `owed ${displayUserBalance}`;
      }

      if (userBalance.userId === currentUser.id) {
        return `owe ${displayUserBalance}`;
      }

      return `owes ${displayUserBalance}`;
    }

    if (userBalance.balance < 0) {
      if (isForSettlement) {
        return `received ${displayUserBalance}`;
      }
      if (userBalance.userId === currentUser.id) {
        return `receive ${displayUserBalance}`;
      }

      return `receives ${displayUserBalance}`;
    }

    if (userBalance.userId === currentUser.id) {
      if (isForSettlement) {
        return "were settled up";
      }
      return "are settled up";
    }

    return isForSettlement ? "was settled up" : "is settled up";
  };

  const balanceClassNames = (userBalance: UserBalance) => {
    if (userBalance.balance > 0) {
      return "text-rose-500";
    }

    if (userBalance.balance < 0) {
      return "text-green-600";
    }

    return "text-indigo-500";
  };

  if (currentUserBalance) {
    return (
      <div className="mt-2">
        <div className={`font-bold ${balanceClassNames(currentUserBalance)}`}>
          {`You ${oweOrReceive(currentUserBalance)}`}
        </div>

        {otherUserBalances.length > 0 && (
          <ul className="mx-8 list-disc sm:list-none">
            {otherUserBalances.map((otherUserBalance) => {
              return (
                <li
                  className={`mb-2 sm:mb-0 ${balanceClassNames(
                    otherUserBalance
                  )}`}
                  key={otherUserBalance.userId}
                >
                  {`${otherUserBalance.firstName} ${
                    otherUserBalance.lastName
                  } ${oweOrReceive(otherUserBalance)}`}
                </li>
              );
            })}
          </ul>
        )}
      </div>
    );
  }

  return null;
};

export default BalancesData;
