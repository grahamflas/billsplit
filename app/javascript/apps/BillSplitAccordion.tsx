import { JSX, PropsWithChildren } from "react";

import { Accordion } from "radix-ui";
import { ChevronDownIcon } from "@radix-ui/react-icons";

interface Props {
  headingContent: string | JSX.Element;
  triggerId?: string;
}

const BillSplitAccordion = ({
  children,
  headingContent,
  triggerId,
}: PropsWithChildren<Props>) => {
  return (
    <Accordion.Root className="AccordionRoot" type="single" collapsible>
      <Accordion.Item className="AccordionItem" value="deleted">
        <Accordion.Header className="bg-white">
          <Accordion.Trigger
            className="flex flex-row justify-between w-full"
            id={triggerId}
          >
            <div className="text-xl">{headingContent}</div>
            <div>
              <ChevronDownIcon />
            </div>
          </Accordion.Trigger>
        </Accordion.Header>

        <Accordion.Content>{children}</Accordion.Content>
      </Accordion.Item>
    </Accordion.Root>
  );
};

export default BillSplitAccordion;
