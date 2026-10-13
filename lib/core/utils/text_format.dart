// Turns a slug like "womens-dresses" into "Womens Dresses" for display,
// while the underlying slug value is still what is used for filtering
// against each product's category field.
String formatCategoryLabel(String slug) {
  return slug
      .split('-')
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
