document.addEventListener('DOMContentLoaded', () => {
  // Target all <details> inside both Guides and Wiki pop-out overlays
  const allDetails = document.querySelectorAll('.box-popout details');

  allDetails.forEach((targetDetail) => {
    targetDetail.addEventListener('toggle', () => {
      // Only execute when the current accordion is being opened
      if (targetDetail.open) {
        allDetails.forEach((detail) => {
          if (detail !== targetDetail && detail.open) {
            detail.removeAttribute('open');
          }
        });
      }
    });
  });
});