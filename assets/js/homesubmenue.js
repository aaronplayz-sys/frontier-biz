document.addEventListener('DOMContentLoaded', () => {
  const popoutDetails = document.querySelectorAll('.box-popout details');
  
  popoutDetails.forEach((targetDetail) => {
    targetDetail.addEventListener('click', () => {
      popoutDetails.forEach((detail) => {
        if (detail !== targetDetail) {
          detail.removeAttribute('open');
        }
      });
    });
  });
});