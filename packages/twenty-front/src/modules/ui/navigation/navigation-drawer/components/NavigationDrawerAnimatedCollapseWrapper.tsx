import { isNavigationDrawerExpandedState } from '@/ui/navigation/states/isNavigationDrawerExpanded';
import { useTheme } from '@emotion/react';
import styled from '@emotion/styled';
import { AnimationControls, motion, TargetAndTransition } from 'framer-motion';
import { useRecoilValue } from 'recoil';

const StyledAnimatedContainer = styled(motion.span)`
  display: block;
`;

export const NavigationDrawerAnimatedCollapseWrapper = ({
  children,
  mobileNavigationDrawer,
}: {
  children: React.ReactNode;
  mobileNavigationDrawer?: boolean;
}) => {
  const theme = useTheme();
  // const isSettingsPage = useIsSettingsPage();
  const isNavigationDrawerExpanded = useRecoilValue(
    isNavigationDrawerExpandedState,
  );

  // if (isSettingsPage) {
  //   return children;
  // }

  const animate: AnimationControls | TargetAndTransition =
    mobileNavigationDrawer
      ? {
          opacity: 0,
            width: 0,
            height: 0,
            pointerEvents: 'none',
        }
      : isNavigationDrawerExpanded
        ? {
            opacity: 1,
            width: 'auto',
            height: 'auto',
            pointerEvents: 'auto',
          }
        : {
            opacity: 0,
            width: 0,
            height: 0,
            pointerEvents: 'none',
          };

  return (
    <StyledAnimatedContainer
      initial={false}
      animate={animate}
      transition={{
        duration: theme.animation.duration.normal,
      }}
    >
      {children}
    </StyledAnimatedContainer>
  );
};
