<template>
  <input
    :value="search"
    @input="updateSearch"
    placeholder="Search by username or ID"
  />
</template>

<script>
export default {
  props: {
    search: String,
  },
  methods: {
    updateSearch(event) {
      this.$emit("update:search", event.target.value);
    },
  },
};
</script>
