String formatStringListAsBullets(List<String> items) =>
    items.map((item) => '- $item').join(('\n'));
