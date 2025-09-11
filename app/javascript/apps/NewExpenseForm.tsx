import { Field, Form, Formik } from "formik";
import { Group } from "../types/BaseInterfaces";
import NewExpenseFormUserSelect from "./NewExpenseFormUserSelect";
import ExpensesRepository from "../repositories/ExpensesRepository";
import GroupDetailsSection from "./GroupDetailsSection";

interface Props {
  groups: Group[];
  initialGroupId?: number;
}

const NewExpenseForm = ({ groups, initialGroupId }: Props) => {
  const fieldClasses =
    "border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6";

  return (
    <div className="flex flex-col gap-6 p-6 max-w-2xl mx-auto">
      <h1 className="font-bold text-4xl">New Expense</h1>

      <GroupDetailsSection>
        <Formik
          initialValues={{
            reference: undefined,
            amount: undefined,
            groupId: initialGroupId || groups[0]?.id || undefined,
            userId: undefined,
          }}
          onSubmit={async (values) => {
            const success = await ExpensesRepository.create(values);

            if (success) {
              window.location.href = `/groups/${values.groupId}`;
            }
          }}
        >
          <Form>
            <label className="text-gray-500" htmlFor="reference">
              Reference
            </label>

            <Field
              className={fieldClasses}
              type="text"
              name="reference"
              id="reference"
            />

            <label className="text-gray-500" htmlFor="amount">
              Amount
            </label>

            <Field
              className={fieldClasses}
              type="number"
              name="amount"
              id="amount"
            />

            <label className="text-gray-500" htmlFor="groupId">
              Group
            </label>

            <Field
              className={fieldClasses}
              as="select"
              name="groupId"
              id="groupId"
            >
              {groups.map((group) => (
                <option value={group.id} key={group.id}>
                  {group.name}
                </option>
              ))}
            </Field>

            <label className="text-gray-500" htmlFor="userId">
              Paid by
            </label>

            <NewExpenseFormUserSelect
              fieldClasses={fieldClasses}
              groups={groups}
              id="userId"
            />

            <button
              type="submit"
              className="w-full bg-indigo-500 hover:bg-indigo-600 focus:outline-indigo-900 rounded-md text-white py-2 mb-6 cursor:pointer"
            >
              Create Expense
            </button>
          </Form>
        </Formik>
      </GroupDetailsSection>
    </div>
  );
};

export default NewExpenseForm;
