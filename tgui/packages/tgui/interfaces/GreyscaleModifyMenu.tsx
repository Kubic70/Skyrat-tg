import { useBackend } from '../backend';
import { Box, Button, ColorBox, Flex, Stack, Icon, Input, LabeledList, Section, Table, Divider } from '../components';
import { Window } from '../layouts';

type ColorEntry = {
  index: Number;
  value: string;
}

type SpriteData = {
  icon_states: string[];
  finished: string;
  steps: SpriteEntry[];
  time_spent: Number;
}

type SpriteEntry = {
  layer: string;
  result: string;
  config_name: string;
}

type GreyscaleMenuData = {
  colors: Array<ColorEntry>;
  sprites: SpriteData;
}

const ColorDisplay = (props, context) => {
  const { act, data } = useBackend<GreyscaleMenuData>(context);
  const colors = (data.colors || []);
  return (
    <Section title="Colors">
      <LabeledList>
        <LabeledList.Item
          label="Full Color String">
          <Button
            icon="dice"
            onClick={() => act("random_all_colors")}
            tooltip="Randomizes all color groups."
          />
          <Input
            value={colors.map(item => item.value).join('')}
            onChange={(_, value) => act("recolor_from_string", { color_string: value })}
          />
        </LabeledList.Item>
        {colors.map(item => (
          <LabeledList.Item
            key={`colorgroup${item.index}${item.value}`}
            label={`Color Group ${item.index}`}
            color={item.value}
          >
            <ColorBox
              color={item.value}
            />
            {" "}
            <Button
              content={<Icon name="palette" />}
              onClick={() => act("pick_color", { color_index: item.index })}
              tooltip="Brings up a color pick window to replace this color group."
            />
            <Button
              icon="dice"
              onClick={() => act("random_color", { color_index: item.index })}
              tooltip="Randomizes the color for this color group."
            />
            <Input
              value={item.value}
              width={7}
              onChange={(_, value) => act("recolor", { color_index: item.index, new_color: value })}
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const PreviewCompassSelect = (props, context) => {
  const { act, data } = useBackend<GreyscaleMenuData>(context);
  return (
    <Box>
      <Stack vertical>
        <Flex>
          <SingleDirection dir={Direction.NorthWest} />
          <SingleDirection dir={Direction.North} />
          <SingleDirection dir={Direction.NorthEast} />
        </Flex>
        <Flex>
          <SingleDirection dir={Direction.West} />
          <Flex.Item grow={1} basis={0}>
            <Button lineHeight={3} m={-0.2} fluid>
              <Icon name="arrows-alt" size={1.5} m="20%" />
            </Button>
          </Flex.Item>
          <SingleDirection dir={Direction.East} />
        </Flex>
        <Flex>
          <SingleDirection dir={Direction.SouthWest} />
          <SingleDirection dir={Direction.South} />
          <SingleDirection dir={Direction.SouthEast} />
        </Flex>
      </Stack>
    </Box>
  );
};

const SingleDirection = (props, context) => {
  const { dir } = props;
  const { data, act } = useBackend<GreyscaleMenuData>(context);
  return (
    <Flex.Item grow={1} basis={0}>
      <Button
        content={DirectionAbbreviation[dir]}
        tooltip={`Sets the direction of the preview sprite to ${dir}`}
        disabled={`${dir}` === data.sprites_dir ? true : false}
        textAlign="center"
        onClick={() => act("change_dir", { new_sprite_dir: dir })}
        lineHeight={3}
        m={-0.2}
        fluid
      />
    </Flex.Item>
  );
};

const IconStatesDisplay = (props, context) => {
  const { data, act } = useBackend<GreyscaleMenuData>(context);
  return (
    <Section title="Icon States">
      <Flex>
        {
          data.sprites.icon_states.map(item => (
            <Flex.Item key={item}>
              <Button
                mx={0.5}
                content={item ? item : "Blank State"}
                disabled={item === data.icon_state}
                onClick={() => act("select_icon_state", { new_icon_state: item })}
              />
            </Flex.Item>
          ))
        }
      </Flex>
    </Section>
  );
};

const PreviewDisplay = (props, context) => {
  const { data } = useBackend<GreyscaleMenuData>(context);
  return (
    <Section title="Preview">
      <Table>
        <Table.Row>
          <Table.Cell width="50%">
            <PreviewCompassSelect />
          </Table.Cell>
          {
            data.sprites?.finished
              ? (
                <Table.Cell>
                  <Box as="img" src={data.sprites.finished} m={0} width="75%" mx="10%" style={{ "-ms-interpolation-mode": "nearest-neighbor" }} />
                </Table.Cell>
              )
              : (
                <Table.Cell>
                  <Box grow>
                    <Icon name="image" ml="25%" size={5} style={{ "-ms-interpolation-mode": "nearest-neighbor" }} />
                  </Box>
                </Table.Cell>
              )
          }
        </Table.Row>
        {data.sprites.steps.map(item => (
          <Table.Row key={`${item.result}|${item.layer}`}>
            <Table.Cell width="50%"><SingleSprite source={item.result} /></Table.Cell>
            <Table.Cell width="50%"><SingleSprite source={item.layer} /></Table.Cell>
          </Table.Row>
        ))}
      </Table>
      {
        !!data.generate_full_preview
          && `Time Spent: ${data.sprites.time_spent}ms`
      }
      <Divider />
      {
        !data.refreshing
          && (
            <Table>
              {
                !!data.generate_full_preview && data.sprites.steps !== null
                  && (
                    <Table.Row header>
                      <Table.Cell width="50%" textAlign="center">Layer Source</Table.Cell>
                      <Table.Cell width="25%" textAlign="center">Step Layer</Table.Cell>
                      <Table.Cell width="25%" textAlign="center">Step Result</Table.Cell>
                    </Table.Row>
                  )
              }
              {
                !!data.generate_full_preview && data.sprites.steps !== null
                  && data.sprites.steps.map(item => (
                    <Table.Row key={`${item.result}|${item.layer}`}>
                      <Table.Cell verticalAlign="middle">{item.config_name}</Table.Cell>
                      <Table.Cell>
                        <SingleSprite source={item.layer} />
                      </Table.Cell>
                      <Table.Cell>
                        <SingleSprite source={item.result} />
                      </Table.Cell>
                    </Table.Row>
                  ))
              }
            </Table>
          )
      }
    </Section>
  );
};

const SingleSprite = (props) => {
  const {
    source,
  } = props;
  return (
    <Box
      as="img"
      src={source}
      width="100%"
      style={{ "-ms-interpolation-mode": "nearest-neighbor" }}
    />
  );
};

export const GreyscaleModifyMenu = (props, context) => {
  const { act, data } = useBackend<GreyscaleMenuData>(context);
  return (
    <Window
      title="Greyscale Modification"
      width={325}
      height={800}>
      <Window.Content scrollable>
        <ColorDisplay />
        <Button
          content="Refresh Icon File"
          onClick={() => act("refresh_file")}
        />
        {" "}
        <Button
          content="Apply"
          onClick={() => act("apply")}
        />
        <PreviewDisplay />
      </Window.Content>
    </Window>
  );
};
